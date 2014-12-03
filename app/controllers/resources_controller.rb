class ResourcesController < ApplicationController

  def index
    @programs = Program.all.order('lower(loan_type) ASC')
    @steps = ProcessStep.all.order('step_number ASC')
    @questions = Question.all.order('question_number ASC')
  end

  #loan programs
  def new_program
    p = Program.new
    p.loan_type = params['loan_type']
    p.description = params['description']
    if p.save
      flash[:notice] = 'Program created'
    else
      flash[:error] = 'Program not created.  Try again or contact system administrator'
    end
    redirect_to resources_path(tab: 'programs')
  end

  def edit_program
    p = Program.find(params['id'])
    p.loan_type = params['loan_type']
    p.description = params['description']
    if p.save
      flash[:notice] = 'Program updated'
    else
      flash[:error] = 'Program not updated.  Try again or contact system administrator'
    end
    redirect_to resources_path(tab: 'programs')
  end

  def delete_program
    Program.find(params['id']).destroy
    redirect_to resources_path(tab: 'programs')
  end

  #loan process
  def new_process
    reorder = ProcessStep.where("step_number >= ?", params['step_order'].to_i)
    reorder.each do |r|
      r.step_number += 1
      r.save
    end
    p = ProcessStep.new
    p.name = params['step_name']
    p.description = params['description']
    p.step_number = params['step_order'].to_i
    if p.save
      flash[:notice] = 'Process Step Added'
    else
      flash[:error] = 'Process Step Not Added'
    end
    redirect_to resources_path(tab: "process")
  end

  def edit_process
    step = ProcessStep.find(params['id'])
    step.name = params['edit_step_name']
    step.description = params['description']
    if step.save
      flash[:notice] = 'Process Step Updated'
    else
      flash[:error] = 'Process Step Not Updated'
    end
    redirect_to resources_path(tab: "process")
  end

  def delete_process
    delete = ProcessStep.find(params['id'])
    reorder = ProcessStep.where('step_number > ?', delete.step_number)
    reorder.each do |r|
      r.step_number -= 1
      r.save
    end
    delete.destroy!
    redirect_to resources_path(tab: "process")
  end

  def swap
    elements = params['elements']
    item1 = ProcessStep.find(elements['top_id'])
    item2 = ProcessStep.find(elements['bottom_id'])
    item1.step_number = elements['top_new_order'].to_i
    item2.step_number = elements['bottom_new_order'].to_i
    item1.save
    item2.save
    steps = ProcessStep.order('step_number ASC')
    render partial: '/resources/loan_process_accordion', locals: { steps: steps }
  end

  #faq section
  def new_question
    reorder = Question.where("question_number >= ?", params['question_order'].to_i)
    reorder.each do |r|
      r.question_number += 1
      r.save
    end
    p = Question.new
    p.question = params['question']
    p.answer = params['answer']
    p.question_number = params['question_order'].to_i
    if p.save
      flash[:notice] = 'Question Added'
    else
      flash[:error] = 'Question Not Added'
    end
    redirect_to resources_path(tab: "faq")
  end

  def edit_question
    question = Question.find(params['id'])
    question.question = params['edit_question']
    question.answer = params['edit_answer']
    if question.save
      flash[:notice] = 'Question Updated'
    else
      flash[:error] = 'Question Not Updated'
    end
    redirect_to resources_path(tab: "faq")
  end

  def delete_question
    delete = Question.find(params['id'])
    reorder = Question.where('question_number > ?', delete.question_number)
    reorder.each do |r|
      r.question_number -= 1
      r.save
    end
    delete.destroy!
    redirect_to resources_path(tab: "faq")
  end

  def swap_question
    elements = params['elements']
    item1 = Question.find(elements['top_id'])
    item2 = Question.find(elements['bottom_id'])
    item1.question_number = elements['top_new_order'].to_i
    item2.question_number = elements['bottom_new_order'].to_i
    item1.save
    item2.save
    questions = Question.order('question_number ASC')
    render partial: '/resources/faq_accordion', locals: { questions: questions }
  end

end
