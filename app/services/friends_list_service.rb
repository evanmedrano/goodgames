class FriendsListService
  def initialize(user, params = {})
    @user = user
    @params = params
  end

  def friends
    if params.include?(:sort_by)
      return sorted_friends
    elsif params.include?(:search)
      return searched_friends
    end

    friends_list
  end

  private

  attr_reader :params, :user

  def sorted_friends
    case sort_by
    when "first_name"
      order_by_first_name
    when "last_name"
      order_by_last_name
    when "date_added"
      order_by_date_added
    when "games_added"
      order_by_games_added
    when "friends_added"
      order_by_friends_added
    end
  end

  def searched_friends
    friends_list.where(
      'first_name iLIKE ? OR last_name iLIKE ?', first_name, last_name
    )
  end

  def sort_by
    params[:sort_by]
  end

  def search
    if search_has_multiple_words?
      first_name = params[:search].split[0]
      last_name = params[:search].split[1]

      { first_name: first_name, last_name: last_name }
    else
      { first_name: params[:search], last_name: params[:search] }
    end
  end

  def order_by_first_name
    friends_list.order(first_name: :asc)
  end

  def order_by_last_name
    friends_list.order(last_name: :asc)
  end

  def order_by_date_added
    friends_list.order(created_at: :desc)
  end

  def order_by_games_added
    order_friends_by("games")
  end

  def order_by_friends_added
    order_friends_by("friends")
  end

  def friends_list
    User.all_friends_of(user)
  end

  def order_friends_by(sorting)
    friends_list.sort do |friend_a, friend_b|
      if friend_a.send(sorting).size == friend_b.send(sorting).size
        friend_a.first_name <=> friend_b.first_name
      else
        friend_b.send(sorting).size <=> friend_a.send(sorting).size
      end
    end
  end

  def search_has_multiple_words?
    params[:search].split.length >= 2
  end

  def first_name
    search[:first_name]
  end

  def last_name
    search[:last_name]
  end
end
