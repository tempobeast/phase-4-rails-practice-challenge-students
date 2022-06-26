class StudentsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    
    def index
        students = Student.all
        render json: students, status: :ok
    end

    def show
        student = find_student
        render json: student, status: :ok
    end

    def create
        instructor = Instructor.find_by(name: params[:instructor_name])
        if instructor
            student = Student.create!(
                name: params[:name],
                major: params[:major],
                age: params[:age],
                instructor_id: instructor.id
                )
            render json: student, status: :created
        else
            render json: { errors: "Instructor must exist" }, status: :unprocessable_entity
        end
    end

    def update
        student = find_student
        student.update!(student_params)
        render json: student, status: :accepted
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

    private
    def student_params
        params.permit(:name, :major, :age, :instructor_id)
    end

    def find_student
        Student.find(params[:id])
    end

    def render_not_found_response(invalid)
        render json: { errors: "Student not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end


end
