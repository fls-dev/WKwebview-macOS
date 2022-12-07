//
//  JSUserScripts.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 3.12.22.
//

import Foundation

let setDataL  = """
var swiftIdBan = document.querySelector('.startBoxBanner').id;
var swiftSceneElm = document.querySelector('#'+swiftIdBan+'> .HYPE_scene[style*="block"]');
document.addEventListener('click', (e)=>{
    console.log(e.target)
    if(e.target.classList.contains('btn-login')){
        localStorage.setItem("datalcrm", swiftSceneElm.querySelector('.login-email').value);
        localStorage.setItem("datapcrm", swiftSceneElm.querySelector('.login-password').value);
    }
})
"""

let getDataL  = """
var ll = localStorage.getItem('datalcrm');
var pp = localStorage.getItem('datapcrm');
var swiftIdBan = document.querySelector('.startBoxBanner').id;
var swiftSceneElm = document.querySelector('#'+swiftIdBan+'> .HYPE_scene[style*="block"]');
swiftSceneElm.querySelector('.login-email').value = ll;
swiftSceneElm.querySelector('.login-password').value = pp;
"""

let printScreen  = """
document.addEventListener("DOMContentLoaded", function() {
window.focus();
window.print();
})
"""

let getPrevUrl  = """
document.referrer
})
"""

//login
