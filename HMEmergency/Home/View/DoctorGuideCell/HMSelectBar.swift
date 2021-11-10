//
//  HMSelectBar.swift
//  HMEmergency
//
//  Created by 齐浩铭 on 2021/10/2.
//

import UIKit

protocol HMSelectBarDataSource {
    func cellCount() -> Int
    func title(index: Int) -> String
    func selectMessage(index: Int)
}

class HMSelectBar: UICollectionView {
    var myDataSource: HMSelectBarDataSource?

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.estimatedItemSize = CGSize(width: 200, height: 50)
        super.init(frame: CGRect(x: 0, y: 0, width: HMwidth - 20, height: 200), collectionViewLayout: flowLayout)
        autoresizesSubviews = true
        register(cellType: HMSelectBarCell.self)
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hasSelected() -> [String] {
        return ["暂时未完成"]
    }
}

extension HMSelectBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myDataSource?.cellCount() ?? 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HMSelectBarCell.self)

        let text = myDataSource?.title(index: indexPath.row) ?? "标题"
        cell.load(title: text)
        return cell
    }

    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select", indexPath.row)
        let cell: HMSelectBarCell = collectionView.cellForItem(at: indexPath)! as! HMSelectBarCell
        if cell.backgroundColor == UIColor.hexColor(hex: "#efefef") {
            cell.backgroundColor = shareColor.MainColor
            self.myDataSource?.selectMessage(index: indexPath.row)
        } else {
            cell.backgroundColor = UIColor.hexColor(hex: "#efefef")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HMwidth * 0.4, height: 50)
    }
}
