class SessionsController < ApplicationController # виртуальный объект. в БД не присутствует
  def new
  end

  def create # создаем сессию для аутентифицированного(залогиненого) пользователя.
    user = User.authenticate(params[:email], params[:password]) #данные в params приходят из полей email и password вьюхи sessions/new.html.erb

    if user.present? # в application_controller ссылка на текущего пользователя, залогинен он или нет.
      session[:user_id] = user.id # session - состояние залогинености юзера. session обычно живет пока в браузере открыто окно
      redirect_to root_path, notice: 'Вы успешно залогинились'
    else
      flash.now.alert = 'Неправильный email или password' #now говорит что сообщение будет выведено прямо в этом запросе
      render :new #рендерим вновь эту же форму sessions/new.html.erb
    end
  end

  def destroy # разлогиневаем пользователя, заканчиваем сессию
    session[:user_id] = nil
    redirect_to root_path, notice: 'Вы разлогинелись! Приходите еще!'
  end
end
