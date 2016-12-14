class AnswersController < ApplicationController
  def create
    @question = Question.find params[:question_id]
    @answer = Answer.new(answer_attributes.to_h.merge(question_id: params[:question_id]))
    if @answer.save
      redirect_to :back, notice: "Answer created successfully."
    else
      render "/answer_questions"
    end
  end


  private

  def answer_attributes
    params.require(:answer).permit([:body, :user_id])
  end
end
