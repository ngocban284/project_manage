# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Các gem lạ 

* gem 'public_activity' : theo dõi hoạt động của controller. 

    include PublicActivity::StoreController vào application_controller
    @activities = PublicActivity::Activity.order("created_at DESC").where(owner_id: current_user, owner_type: "User")
    ==> đây là cách lấy biến @activities từ 1 đối tượng trong controller nhằm sử dụng để theo dõi 

    include PublicActivity::Model
	tracked owner: Proc.new { |controller, model| controller.current_user }
    => phải thêm vào model cần theo dõi thì mới sử dụng được public_activities

    -trackable là polymorphic association, nó có tất cả thông tin cần thiết về mô hình đã được sửa đổi và sử dụng trong view như sau :
    <% if activity.trackable %>
		<%= link_to activity.trackable.name, activity.trackable %>
	<% else %>

    <%= render_activities(@activities) %> được sử dụng trong view home để gọi những gì liên quan đến biến @activities được định nghĩa trong home_controller 

    user controller cũng như user trong db cần phải kích hoạt :trackable thì mới có
    thể tiếp tục sử dụng activititestrackable trong view  
    

* gem 'mailcatcher' sử dụng để check mail đã được gửi cho người dùng chưa 
    
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { :address => '127.0.0.1', :port => 1025 }
    config.action_mailer.raise_delivery_errors = false
    => thêm vào config/development để thực hiện giửi mail xác thực tài khoản 


* gem 'wysiwyg-rails' sử dụng để điều chỉnh chữ , thêm hình ảnh kiểu như word 

# Các lưu ý đặc biệt khác 

* confirmation controller : xác nhận người dùng qua mail . thêm ở controller , config/development để thực hiện gửi mail xác thực 

* muốn dùng biến gì tại patch nào thì thêm @ten_bien vào hàm định nghĩa patch controller đó . ví dụ  :
def new
    @project = current_user.projects.build
    @teams = Team.where('id = ?', current_user.team_id)
end

   - Nếu lấy biến từ 1 controller khác thường dùng where . ví dụ : 
    @teams = Team.where('id = ?', current_user.team_id)
  	@projects = Project.where('team_id = ?', current_user.team_id)

   - Nếu lấy biến từ user từ devise  . ví dụ :
    @user = current_user
    
   - Nếu muốn tìm được 'id = ?' , current_id hay @user = current_user thì phải có 
   params của những đối tượng đó . ví dụ :

   params của project: params.require(:project).permit(:name, :description , :team_id)
   vì project có sử dụng team_id để tìm ra teams 

   params của team : params.require(:team).permit(:name , user_attributes: [:id,:name , :email ,:_destroy])
   vì team có sử dụng biến @user = user_current 
 
* muốn thêm hàm tự chế thì thêm trong helper để dùng trong view 

* muốn thêm webpacker thì thêm thẻ javascript_pack_tag vào file view cần thêm 

* vuejs là 1 framework của js giúp xây dựng giao diện người dùng 

* accepts_nested_attributes_for trong model :cho phép lưu bản ghi của đối tượng thông qua đối tượng cha của nó. ví dụ : 
    class Book < ActiveRecord::Base
        has_one :author
        has_many :pages

        accepts_nested_attributes_for :author, :pages
    end
    => cho phép book sử dụng thuộc tính của author và pages thông qua việc tạo ra 
    author_attributes và pages_attributes . Từ đó sử dụng trong controller của book
    => chỉ dùng cho Model  (has_many , has_one,belongs_to, ....)

* <%= safe_join(team.users.map { |user| user.name }, ', ') %>
    => Đây là phương thức trả về tất cả phần tử user dưới dạng html safe

* 