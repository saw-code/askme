class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1,
        name: 'Vadim',
        username: 'installero',
        avatar_url: 'https://secure.gravatar.com/avatar/' \
          '71269686e0f757ddb4f73614f43ae445?s=100'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Vadim',
      username: 'installero',
      avatar_url: 'https://secure.gravatar.com/avatar/71269686e0f757ddb4f73614f43ae445?s=100'
    )

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('07.10.2021')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('07.10.2021')),
      Question.new(text: 'А есть ли этот смысл?', created_at: Date.parse('15.11.2021')),
      Question.new(text: 'Что делаешь?', created_at: Date.parse('15.11.2021')),
      Question.new(text: 'Пойдешь гулять?', created_at: Date.parse('15.11.2021')),
      Question.new(text: 'Во сколько ложишься спать?', created_at: Date.parse('15.11.2021')),
      Question.new(text: 'Уже стал программистом?', created_at: Date.parse('15.11.2021')),
      Question.new(text: 'Что такое руби?', created_at: Date.parse('15.11.2021')),
    ]

    @questions_amount = @questions.count

    @new_question = Question.new
  end
end
