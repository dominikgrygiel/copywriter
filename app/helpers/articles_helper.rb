module ArticlesHelper

  def editable?(obj)
    signed_in? && current_user.can_edit?(obj)
  end

end

