//
//  DlgBookTimeChooser.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import UIKit

class DlgBookTimeChooser: DelViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    struct Property  {
        static let hourStartBook = 800
        static let hourEndBook = 2000
    }
    
    class DataTime {
        var startTime: Int = 0
        var endTime: Int = 0
        init(startTime: Int, endTime: Int) {
            self.startTime = startTime
            self.endTime = endTime
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(TimeChooserCell.self, forCellWithReuseIdentifier: "timechooser-cell")
        return collection
    }()
    
    private lazy var btnSave: DelButton = {
        let btn = DelButton()
        btn.setTitle("Save")
        return btn
    }()
    
    private lazy var btnCancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        return btn
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        return datepicker
    }()
    
    private lazy var viewModel: DelClinicViewModel = DelClinicViewModel()
    var currentClinicCode: String = ""
    var currentDoctorCode: String = ""
    var listBooked: [BookedModel] = []
    var listEntry: [DataTime] = []
    var delegate: ((String, Int, Int) -> Void)? = nil
    var selectedStartTime: Int = 0
    var selectedEndTime: Int = 0
    var selectedIndex: Int = -1
    var selectedDatetime: String = Date.getCurrentDatetime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackViewBtn = UIStackView()
        stackViewBtn.axis = .horizontal
        stackViewBtn.spacing = 9
        stackViewBtn.distribution = .fillEqually
        view.addSubview(stackViewBtn)
        stackViewBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        stackViewBtn.addArrangedSubview(btnCancel)
        btnCancel.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        stackViewBtn.addArrangedSubview(btnSave)
        btnSave.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        let line = UIView()
        line.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(stackViewBtn.snp.bottom).offset(9)
            make.height.equalTo(1)
        }
        
        datePicker.addTarget(self, action: #selector(onDateChange(sender:)), for: .valueChanged)
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        reloadListEntry()
        
        // listener
        btnCancel.addTapGestureListener(action: {
            self.dismiss(animated: true)
        })
        
        btnSave.addTapGestureListener(action: {
            self.delegate?(self.selectedDatetime,
                           self.selectedStartTime, self.selectedEndTime)
            self.dismiss(animated: true)
        })
        
        // observer
        viewModel.liveBook.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.hideWait()
                self.listBooked = data
                self.selectedIndex = -1
                self.selectedStartTime = 0
                self.selectedEndTime = 0
                self.reloadListEntry()
                self.collectionView.reloadData()
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func reloadListEntry() {
        listEntry = []
        var time = Property.hourStartBook
        while time <= Property.hourEndBook {
            if isInRange(time) {
                listEntry.append(DataTime(startTime: time, endTime: time+100))
            }
            time += 100
        }
    }
    
    private func isInRange(_ time: Int) -> Bool {
        for book in listBooked {
            if time >= book.startTime && time <= book.endTime {
                return false
            }
            if (time+100) >= book.startTime && (time+100) <= book.endTime {
                return false
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listEntry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timechooser-cell", for: indexPath) as? TimeChooserCell else {
            return UICollectionViewCell()
        }
        
        let data = listEntry[indexPath.row]
        cell.label.text = "\(data.startTime.toTime()) - \(data.endTime.toTime())"
        cell.contentView.addTapGestureListener(action: {
            self.selectedIndex = indexPath.row
            self.selectedStartTime = data.startTime
            self.selectedEndTime = data.endTime
            self.collectionView.reloadData()
        })
        
        if self.selectedIndex == indexPath.row {
            cell.setSelected()
        } else {
            cell.setUnselected()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func onDateChange(sender: UIDatePicker) {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        self.selectedDatetime = format.string(from: sender.date)
        self.dismiss(animated: true)
        
        // request for change date
        self.showWait()
        self.viewModel.requestBookList(self.currentClinicCode, codeDoctor: self.currentDoctorCode,
                                       datetime: self.selectedDatetime)
    }
}
