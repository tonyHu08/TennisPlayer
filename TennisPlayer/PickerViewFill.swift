import UIKit

extension NewPlayerController: UIPickerViewDelegate, UIPickerViewDataSource {


    // 列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 10:
            return 2
        case 11:
            return 3
        default:
            return 1
        }
    }


    //行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 10:
            if component == 0 {
                return self.nation.count
            } else {
                if nationSelect != [] {
                    return self.nation[nationSelect[0]].countries.count
                } else {
                    return self.nation[pickerView.selectedRow(inComponent: 0)].countries.count
                }
            }
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 10:
            if component == 0 {
                return self.nation[row].continent
            } else {
                return self.nation[pickerView.selectedRow(inComponent: 0)].countries[row]
            }
        default:
            return ""
        }
    }

// 刷新第二列
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nationSelect = []
        if pickerView.tag == 10 {
            if component == 0 {
                pickerView.reloadAllComponents()
                pickerView.selectRow(0, inComponent: 1, animated: false)
                continent = row
                nationPickerSelect = self.nation[pickerView.selectedRow(inComponent: 0)].countries[0]

            } else {
                nationPickerSelect = self.nation[pickerView.selectedRow(inComponent: 0)].countries[row]
            }
        }
    }

// 左右比例
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var componentWidth: CGFloat = 0.0
        if pickerView.tag == 10 {
            if component == 0 {
                componentWidth = 150.0
            } else {
                componentWidth = 230.0
            }
        }
        return componentWidth
    }


}
