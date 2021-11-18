module QuestionsAmountHelper
  def questions_count_helper(questions_amount, vopros, voprosa, voprosov)
    return voprosov if (11..14).include?(questions_amount % 100)

    remainder_of_10 = questions_amount % 10

    if (2..4).include?(remainder_of_10)
      voprosa
    elsif remainder_of_10 == 1
      vopros
    else
      voprosov
    end
  end
end
