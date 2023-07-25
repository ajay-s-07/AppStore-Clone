//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by Ajay Sarkate on 21/07/23.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
    
    init() {
        
        // let layout = UICollectionViewCompositionalLayout(section: section)
        let layout = UICollectionViewCompositionalLayout {
            (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            }
            else {
                
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let kind = UICollectionView.elementKindSectionHeader
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                
                return section
            }
            
        }
        
        super.init(collectionViewLayout: layout)
    }
    
/*  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        
        var title: String?
        if indexPath.section == 1 {
            title = games?.feed.title
        }
        else {
            title = games2?.feed.title
        }
        header.label.text = title
        return header
    }
*/
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
        let label2 = UILabel(text: "Top Paid Apps", font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var socialApps = [SocialApp]()
    var games: AppGroup?
    var games2: AppGroup?
    
    private func fetchApps() {
        Service.shared.fetchSocialApps { apps, err in
            
            self.socialApps = apps ?? []
            
            Service.shared.fetchGames { appGroup, err in
                self.games = appGroup
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            Service.shared.fetchGames2 { appGroup, err in
                self.games2 = appGroup
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
/*  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return socialApps.count
        }
        else if section == 1 {
            return games?.feed.results.count ?? 0
        }
        return games2?.feed.results.count ?? 0
    }
*/
    
/*  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var appId: String
        
        if indexPath.section == 0 {
            appId = socialApps[indexPath.item].id
        }
        else if indexPath.section == 1{
            appId = games?.feed.results[indexPath.item].id ?? ""
        }
        else {
            appId = games2?.feed.results[indexPath.item].id ?? ""
        }
        
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
*/
    
/*  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            
                let socialApp = self.socialApps[indexPath.item]
                cell.titleLabel.text = socialApp.tagline
                cell.companyLabel.text = socialApp.name
                loadImage(in: cell.imageView, from: socialApp.imageUrl)
            
                return cell
            
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            
                let app = games?.feed.results[indexPath.item]
                cell.companyLabel.text = app?.artistName
                cell.nameLabel.text = app?.name
                loadImage(in: cell.imageView, from: app?.artworkUrl100 ?? "")

                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            
                let app = games2?.feed.results[indexPath.item]
                cell.companyLabel.text = app?.artistName
                cell.nameLabel.text = app?.name
                loadImage(in: cell.imageView, from: app?.artworkUrl100 ?? "")

                return cell
        }
        
    }
*/
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Games", style: .plain, target: self, action: #selector(handleFetchGames))
        
//        fetchApps()
        setupDiffableDatasource()
    }
    
    @objc fileprivate func handleFetchGames() {
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json") { appGroup, err in
            print(123)
//            if let err = err {
//                return
//            }
            
            var snapshot = self.diffableDatasource.snapshot()
            
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            
            self.diffableDatasource.apply(snapshot)
        }
    }
    
    enum AppSection {
        case topSocial
        case grossing
        case freeGames
        case topFree
    }
    
    lazy var diffableDatasource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            cell.app = object
            
            return cell
        }
        else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            cell.app = object
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            
            return cell
        }
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        
        var superview = button.superview
        
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectClicked = diffableDatasource.itemIdentifier(for: indexPath) else { return }
                var snapshot = diffableDatasource.snapshot()
                snapshot.deleteItems([objectClicked])
                diffableDatasource.apply(snapshot)
            }
            superview = superview?.superview
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDatasource.itemIdentifier(for: indexPath)
        
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            
            navigationController?.pushViewController(appDetailController, animated: true)
        }
        else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    private func setupDiffableDatasource() {
        
        
//        var snapshot = diffableDatasource.snapshot()
//        snapshot.appendSections([.topSocial])
//        snapshot.appendItems([
//            SocialApp(id: "id0", name: "Facebook", imageUrl: "image1", tagline: "Just Do It.."),
//            SocialApp(id: "id1", name: "Instagram", imageUrl: "image1", tagline: "tagline0")
//        ], toSection: .topSocial)
//
//        diffableDatasource.apply(snapshot)
        
        collectionView.dataSource = diffableDatasource
        
        diffableDatasource.supplementaryViewProvider = .some({
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            let snapshot = self.diffableDatasource.snapshot()
            let object = self.diffableDatasource.itemIdentifier(for: indexPath)
            snapshot.sectionIdentifier(containingItem: object!)
            let section = snapshot.sectionIdentifier(containingItem: object!) as! AppSection
            
            if section == .freeGames {
                header.label.text = "Top Free Apps"
            }
            else{
                header.label.text = "Top Paid Apps"
            }
            
            return header
        })
        
        Service.shared.fetchSocialApps { socialApps, err in
            
            Service.shared.fetchGames2 { appGroup, err in
                
                Service.shared.fetchGames { group, err in
                    
                    var snapshot = self.diffableDatasource.snapshot()
                    snapshot.appendSections([.topSocial, .grossing, .freeGames])
                    
                    // social
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    // games2 / paid
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .grossing)
                    
                    // games / free
                    snapshot.appendItems(group?.feed.results ?? [], toSection: .freeGames)
                    
                    self.diffableDatasource.apply(snapshot)
                }
            }
            
        }
    }
    
    func loadImage(in view: UIImageView, from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                guard let data = data else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    view.image = image
                }
                
            }.resume()
        }
    }

}

struct AppsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AppsView>) ->  UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}



