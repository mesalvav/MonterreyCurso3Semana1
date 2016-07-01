//
//  ViewController.swift
//  Request
//
//  Created by Mario E Salvatierra V on 6/28/16.
//  Copyright © 2016 Dunas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //var texto: NSString!
    
    
    @IBOutlet weak var ISBNtextField: UITextField!
    
    @IBOutlet weak var tituloTextFiled: UITextView!
 
    @IBOutlet weak var AutorTextFiled: UITextView!
    @IBOutlet weak var portadaImageView: UIImageView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        
        
        let (titulo , portada , autores) = sincrono(ISBNtextField.text!)
        print("titulo === \(titulo)")
        print("portada === \(portada)")
        print("autores === \(autores)")
        var stringAutores = ""
        let numerosdeElementos = autores.count
        
        if autores.count > 1 {
            
            for i in 1..<numerosdeElementos {
                stringAutores = stringAutores + autores[i]

            }
        } else { stringAutores = "Sin autor" }
        
        let imagePortada = getLaImagen(portada)
        
        tituloTextFiled.text = titulo
        AutorTextFiled.text = stringAutores
        portadaImageView.image = imagePortada
        
        self.ISBNtextField.endEditing(true)
        return true
    }
    
    func getLaImagen(direccion: String) -> UIImage? {
        
        let url = NSURL(string: direccion)
        
        if let datos: NSData = NSData(contentsOfURL: url!) {
            let imagenPortada = UIImage(data: datos)
            return imagenPortada
        }
        
        let noImage: UIImage? = nil
        
        return noImage
    }
    
    //Su programa deberá sustituir el último código de la URL anterior (en este caso 978-84-376-0494-7 ) por lo que se ponga en la caja de texto
    func sincrono(ISBN: String)   -> (titulo: String, portada: String, autores: [String] ) {
       // let urlstr = "http://dia.ccm.itesm.mx"
        let urlstr = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let url = NSURL(string: urlstr)
    
        
        if let datos: NSData = NSData(contentsOfURL: url!) {
            //data to json
            return procesarDatum(datos, ISBN: ISBN)
            
        }
        
        let alert = UIAlertController(title: "OJO", message: "Parece que no hay conexion al Internet", preferredStyle: .Alert)
       // print(texto!)
        let accion = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(accion)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        return ("error de internet", "error", ["error"])
    }
    
    func procesarDatum(datos: NSData, ISBN:String) -> (titulo: String, portada: String, autores: [String]) {
        var title = "Sin Titulo"
        var unaPortada = ""
        var nombreAutores = ["Sin Autor"]
        
        do {
            let json =
                try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
            //diccionario primario
            let dico1 = json as! NSDictionary
            let isbn = "ISBN:" + ISBN
           
            // el titulo
            
            
            title = dico1[isbn]!["title"] as! String
            print("titulo es: \(title)")
           
            //los autores
        
            let autores = dico1[isbn]!["authors"] as! [NSDictionary]
            
            // varios test this 978-03-879-5584-1
            for author in autores {
                let nombre = author["name"] as! String
                nombreAutores.append(nombre)
                //print("Nombre \(nombre)")
            }
            
            print("Autores \(nombreAutores)")
            
            //la portada??  test this 978-01-560-3119-6 
            var urlDeportadas = ["Sin portada"]
           
            
            if let portadas = dico1[isbn]!["cover"] as! NSDictionary? {
                for ( _ , value) in portadas {
                    let frente = value as! String
                    urlDeportadas.append(frente)
                    
                }
                
                if urlDeportadas.count > 1 {
                unaPortada = urlDeportadas[1]
                }
            }
            print(unaPortada)
            
            return (title, unaPortada, nombreAutores)
            //return 
            
        }
        catch _ {
            print("arrojo algo")
        }
    
        
        return (title, unaPortada, nombreAutores)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.ISBNtextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
/*
 or create a new repository on the command line
 
 echo "# MonterreyCurso3Semana1" >> README.md
 git init
 git add README.md
 git commit -m "first commit"
 git remote add origin https://github.com/mesalvav/MonterreyCurso3Semana2.git
 git push -u origin master
 */
