class ApplicationController < ActionController::Base #эти методы будут доступны во всех контроллерах
  helper_method :current_user # чтобы метод был доступен и во вьюхах используем хелпер helper_method

  private

  def current_user # задаем текущего пользователя если он еще не задан найдя в сессии
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id] # идентификатор
  end # если этот идинтификатор вообще есть. Ссылка на текущего пользователя, залогинен он или нет.

  def reject_user
    redirect_to root_path, alert: 'Вам сюда низя!'
  end
end
