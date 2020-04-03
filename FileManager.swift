//
//  FileManager.swift
//  TearOffAlarm
//
//  Created by admin on 2020/04/01.
//  Copyright © 2020 KoukiTanaka. All rights reserved.
//

import UIKit
//import SwiftFilePath

class MyFileManager{
    var enter_file:(()->Void)!;
    var parent: UIViewController!;
    var FileName:String!;
    var CurrentPath:String!;
    var alert: UIAlertController!;
    let manager = FileManager.default;
    init(){
        
    }
    // 呼び出しもとのView, ファイル選択後に呼び出す関数
    func SetUp(parent_:UIViewController,function:@escaping (()->Void)){
        enter_file = function;
        parent = parent_;
    }
    func SetSearchPath(path:String){
        if(manager.fileExists(atPath: path) == false){
            CurrentPath = NSHomeDirectory();

            //CurrentPath = NSOpenStepRootDirectory();
        }else{
            CurrentPath = path;
        }
        print(CurrentPath);
    }
    func ViewFileManager(){
        do {
            let list = try?manager.contentsOfDirectory(atPath: CurrentPath);
            var FolderList = [String]();
            var FileList = [String]();
            var isDir: ObjCBool = false
            for path in list!{
                if(manager.fileExists(atPath: CurrentPath + "/" + path, isDirectory: &isDir)){
                    if(isDir.boolValue == true){
                        FolderList.append(path)
                    }else{
                        FileList.append(path)
                    }
                }
            }
            alert = UIAlertController(title: "ファイルを選択してください", message: CurrentPath, preferredStyle:  UIAlertController.Style.actionSheet);
            let parentStr:String = self.GetParentPath(path: self.CurrentPath);
            print(parentStr);
            if( parentStr != "" && parentStr != "/"){
                let defaultAction: UIAlertAction = UIAlertAction(title: "../", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.CurrentPath = self.GetParentPath(path: self.CurrentPath);
                    self.ViewFileManager();
                })
                alert.addAction(defaultAction);
            }
            
            for path in FolderList{
                let defaultAction: UIAlertAction = UIAlertAction(title: path+"/", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.ChangeCurrentPath(path: path);
                    self.ViewFileManager();
                })
                alert.addAction(defaultAction)
            }
            for path in FileList{
                let defaultAction: UIAlertAction = UIAlertAction(title: path, style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.ChangeCurrentPath(path: path);
                    self.enter_file();
                })
                alert.addAction(defaultAction)
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.alert.dismiss(animated: false, completion: nil)
            })
            alert.addAction(cancelAction);

            parent.present(alert, animated: false, completion: nil);
        }catch{
            return;
        }
        
        //return files
        
    }
    func ChangeCurrentPath(path:String){
        CurrentPath += "/" + path;
    }
    func GetParentPath(path:String)->String{
        var i:Int;
        for i in 1 ... path.count{
            if(path.suffix(i).prefix(1) == "/"){
                return String(path.prefix(path.count - i));
            }
        }
        return "";
    }
    
}
