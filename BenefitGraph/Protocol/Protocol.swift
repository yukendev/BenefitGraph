

protocol toDetailDelegate {
    func toDetail(year: String, month: String)
}

protocol tableViewReloadDelegate {
    func tableViewReload()
}

protocol setCategoryDelegate {
    func updateCategoryArray()
}

protocol toEditDelegate {
    func toEdit(category: String, year: String, month: String, money: String)
}
