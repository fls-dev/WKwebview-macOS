const swiftIdBan = document.querySelector('.startBoxBanner').id;
const swiftSceneElm = document.querySelector(`#${swiftIdBan} > .HYPE_scene[style*="block"]`);
console.log(swiftSceneElm);
document.addEventListener('click', (e)=>{
    if(e.target.classList.contains('btn-login')){
        console.log(swiftSceneElm.querySelector('.login-email'))
        console.log(swiftSceneElm.querySelector('.login-password'))
        return swiftSceneElm.querySelector('.login-email')
    }
})
