//
//  DelClinicDetailController.swift
//  AssignmentHealthBooking
//
//  Created by yohanes saputra on 14/03/24.
//

import UIKit

class DelClinicDetailController: DelViewController {
    
    private lazy var imgLogo: UIImageView = {
        let img = UIImageView(image: UIImage(named: "logo"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var labelClinicName: DelTextInput = {
        let label = DelTextInput("Clinic Name", placeHolder: "")
        label.setReadOnly()
        return label
    }()
    
    private lazy var labelClinicAddress: DelTextInput = {
        let label = DelTextInput("Clinic Address", placeHolder: "")
        label.setReadOnly()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0   // to remove top padding header view
        tableView.register(DoctorCell.self, forCellReuseIdentifier: "doctor-cell")
        return tableView
    }()
    
    private lazy var viewModel: DelClinicViewModel = DelClinicViewModel()
    
    var clinicModel: ClinicModel? = nil
    var doctorList: [DoctorModel] = []
    var selectedDoctor: DoctorModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar(clinicModel!.name)
        
        view.addSubview(imgLogo)
        imgLogo.snp.makeConstraints { make in
            make.size.equalTo(180)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(imgLogo.snp.bottom).offset(9)
        }
        stackView.addArrangedSubview(labelClinicName)
        stackView.addArrangedSubview(labelClinicAddress)
        labelClinicName.setText(self.clinicModel!.name)
        labelClinicAddress.setText(self.clinicModel!.address)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(stackView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // init observer
        viewModel.liveDoctorList.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.hideWait()
                self.doctorList = data
                self.tableView.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.liveBook.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.hideWait()
                let view = DlgBookTimeChooser()
                view.modalPresentationStyle = .popover
                view.modalTransitionStyle = .crossDissolve
                view.listBooked = data
                view.delegate = { (start,end) in
                    print(start)
                    print(end)
                    
                    if let doctor = self.selectedDoctor {
                        self.showWait()
                        self.viewModel.saveBook(BookedModel(codeUser: UserDefaults.standard.string(forKey: "uid") ?? "-1",
                                                            codeDoctor: doctor.code,
                                                            codeClinic: self.clinicModel!.code,
                                                            startTime: start, endTime: end))
                    }
                    
                }
                self.present(view, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.liveBookSaved.subscribe(onNext: { data in
            DispatchQueue.main.async {
                self.hideWait()
                self.showAlert(message: "Success make appoinment.")
            }
        }).disposed(by: self.disposeBag)
        
        // load data
        self.showWait()
        viewModel.requestDoctorByClinic(self.clinicModel!.code)
    }
}

extension DelClinicDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "Available Doctor"
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 9, left: 0, bottom: 17, right: 0))
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "doctor-cell", for: indexPath) as? DoctorCell else {
            return UITableViewCell()
        }
        let data = self.doctorList[indexPath.row]
        cell.setData(data)
        cell.btnBook.addTapGestureListener(action: {
            self.showWait()
            self.selectedDoctor = data
            self.viewModel.requestBookList(self.clinicModel!.code, codeDoctor: data.code)
        })
        return cell
    }
}
