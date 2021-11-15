module QuestionsAmountHelper
  def questions_count_helper(questions_amount)
    return "У вас #{questions_amount} вопросов" if (11..14).include?(questions_amount % 100)

    remainder_of_10 = questions_amount % 10

    if (2..4).include?(remainder_of_10)
      "У вас #{questions_amount} вопроса"
    elsif remainder_of_10 == 1
      "У вас #{questions_amount} вопрос"
    else
      "У вас #{questions_amount} вопросов"
    end
  end
end
