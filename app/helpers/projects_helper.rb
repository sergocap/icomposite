module ProjectsHelper
  def category_by_path(path, prms)
    if prms['category'].nil? && path == '/'
      return '/'
    elsif !prms['category'].nil?
      return prms['category']
    elsif path.split('/').index('projects')
      ar = path.split('/')
      ind_projects = ar.index('projects')
      ind_project  = ar[ind_projects + 1]
      if (Integer(ind_project) rescue nil)
        return Project.find(ind_project).category
      end
    end
    return '/'
  end

  def color_by_category(category)
    hash_of_colors[category]
  end

  def hash_of_colors
    {
      'Все' => '#3DDA34',
      'Абстракции' => '#993366',
      'Города' => '#3300CC',
      'Животные' => '#CC00FF',
      'Игры' => '#FF3300',
      'Интерьер' => '#990033',
      'Люди' => '#F29236',
      'Минимализм' => '#FF0000',
      'Музыка' => '#003300',
      'Наука' => '#18E247',
      'Природа' => '#4AB224',
      'Спорт' => '#FF9900',
      'Техника' => '#342F56',
      'Фильмы' => '#666600',
      'Другое' => '#B734DA'
    }

  end

end
