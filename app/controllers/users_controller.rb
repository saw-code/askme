class UsersController < ApplicationController
  # before_action выполняются в том порядке в котором расположены
  before_action :load_user, except: [:index, :create, :new] #фильтр контроллера before_action который будет исполняться перед обращением ко всем экшенам. В except указываем где нам не надо вызывать метод Load_user(кроме этих экшенов)
  before_action :authorize_user, except: [:index, :new, :create, :show] # как только выполнен один из методов (redirect или render ), выполнение кода во всех экшенах не будет выполнено

  def index
    @users = User.all
  end

  def new #здесь поьзователи могут заводить новые аккаунты. страница с формой для ввода данных
    if current_user.present?
      redirect_to root_path, alert: 'Вы уже залогинены' # если текущий юзер вообще присутствует перенаправляем на главную страницу application.html.erb и выводим сообщение
    else
      @user = User.new # во вьюхе по адресу users/new.html.erb используем именно этот объект
    end
  end

  def create
    redirect_to root_path, alert: 'Вы уже залогинены' if current_user.present?

    @user = User.new(user_params) #передаем параметры из формы users/new. они записаны в объект params. params[:user] содержит всебе массив хешей которые переданы из формы new

    if @user.save #сюда данные приходят из экшена new. Записаны они в params
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Пользователь успешно зарегистрирован!' #после сохранения перенаправляем на главную страницу (application.html.erb) и с помощью ключа notice передаем сообщение. но notice(который будет положен в объект flash) надо показать в шаблоне
    else
      render :new #если user не сохраняется то рендерим вновь ту же страницу (в которой будут еще выведены ошибки)
    end
  end

  def edit# здесь юзер может править свой профиль
  end# здесь вызывается метод load_user

  def update # здесь редактируем если надо профиль. здесь вызывается метод load_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Данные обновлены!'
    else
      render :edit #рендерим ту же самую страницу если юзер не отредактирован
    end
  end

  def show
    @questions = @user.questions.order(created_at: :desc) #сортируем в порядке убывания даты создания, т.е. самые последние вопросы были наверху. desc - по убыванию. order - метод ActiveRecord который формирует запрос по какому полю сортировать
    @new_question = @user.questions.build #Метод collection.build возвращает один или массив объектов связанного типа. Объект(ы) будут экземплярами с переданными атрибутами, будет создана ссылка через их внешние ключи, но связанные объекты не будут пока сохранены.
    @questions_amount = @questions.count #количество вопросов
    @answers_amount = @questions.where.not(answer: nil).count # количество вопросов с ответами
    @unanswered_amount = @questions_amount - @answers_amount # количество вопросов без ответа
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Аккаунт уничтожен!'
  end

  private

  def authorize_user # запрещаем юзеру если он хочет залезть в чужие потроха
    reject_user unless @user == current_user # выполняет метод reject_user если @user != current_user
  end

  def load_user
    @user ||= User.find(params[:id]) #выбрали юзере в params которого передали id.
  end

  def user_params # у ключа user с помощью метода permit разрешаем набор атрибутов. Мы четко перечисляем какие атрибуты могут быть в params[:user], что бы ничего лишнего в params не пришло кроме нужных нам данных
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :background_header_color, :avatar_url)
  end
end
