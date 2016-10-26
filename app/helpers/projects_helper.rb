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
end
