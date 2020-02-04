class ComposteursController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # @query = params[:query]
    # # @query_on_category = params[:category]

    # # if @query.present?
    #   @composteurs = Composteur.geocoded.global_search(params[:query])
    # # elsif @query_on_category.present?
    # #   categories = @query_on_category.select { |k, v| v == '1' }.keys
    # #   @meals = Meal.geocoded.select { |m| categories.include?(m.category) }
    # else
    @composteurs = Composteur.geocoded
    @composteurs_all = Composteur.all.order(created_at: :asc)
  # end

    @markers = @composteurs.map do |compo|
      {
        lat: compo.latitude,
        lng: compo.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { compo: compo })
      }
    end
  end

  def show
    @composteur = Composteur.find(params[:id])
    # users du composteur = les referents + les utilisateurs non referents
    @users = @composteur.users # tous les utilisateurs du site
    @referents = @users.where(role: "référent") # les referents du composteur
    @not_referents = @users.where(role: "") # les non-referents

    @notification = Notification.new

    # welcomes = @composteur.notifications.where(notification_type: "welcome")
    # depots = @composteur.notifications.where(notification_type: "depot")
    # anomalies = @composteur.notifications.where(notification_type: "anomalie")
    # @notifications = @composteur.notifications.order(created_at: :desc).first(5)
    @notifications = @composteur.notifications.where(notification_type: "welcome").or(@composteur.notifications.where(notification_type: "depot")).or(@composteur.notifications.where(notification_type: "anomalie")).order(created_at: :desc).first(5)
    @messages_notifications = @composteur.notifications.where(notification_type: "message-ref").last
    @messages_admins = @composteur.notifications.where(notification_type: "message-admin").last
  end

  def new
    @composteur = Composteur.new
  end

  def create
    @composteur = Composteur.create(composteur_params)
    if @composteur.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @composteur = Composteur.find(params[:id])
  end

  def update
    @composteur = Composteur.find(params[:id])
    if @composteur.update(composteur_params)
      redirect_to composteur_path
    else
      render :edit
    end
  end

  def send_email
    @composteur = Composteur.find(params[:id])
      if !@composteur.referent_email.nil?
        ContactReferentMailer.send_request(@composteur).deliver_now
        flash[:notice] = "Demande envoyée"
      else
        flash[:notice] = "Votre demande n'a pu aboutir, le référent n'a pas renseigné d'adresse mail"
      end
    redirect_to root_path
  end

  private

  def composteur_params
    params.require(:composteur).permit(:name, :address, :category, :public, :installation_date, :status, :volume, :residence_name, :commentaire, :participants, :composteur_type, :photo)
  end
end
