/**
 * Created by haoransun on 2015/11/28.
 */
function changeSrc(url){
    var imgs = document.getElementsByTagName("img");
    for(var i = 3; i<imgs.length;i++){
        imgs[i].src=url;
    }
}