 /**
 * Created by haoransun on 2015/11/23.
 */
function Function(){
    document.body.setAttribute("style","line-height:1.55em;letter-spacing:-0.035em;font-size: 1.152em;font-family:Hiragino Sans GB;");
    var ps = document.getElementsByTagName("p");
    for(i=0;i<ps.length;i++){
            ps[0].setAttribute("style","margin-top:1em")
    }
    var contents = document.getElementsByClassName("content");
    for(i=0;i<contents.length;i++){
        contents[i].setAttribute("style","width:91%;margin-left:4.5%;margin-right:4.5%")
    }
}