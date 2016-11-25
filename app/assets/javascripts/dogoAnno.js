this.dogoAnno = {}

dogoAnno.load = function(){
  anno.makeAnnotatable(document.getElementById('document'));
}
dogoAnno.activateSelector = function(){
  anno.activateSelector();
}
dogoAnno.reset = function(){
  anno.reset();
}
dogoAnno.destroy = function(){
  anno.destroy();
}
dogoAnno.test = function(){
  alert('works!');
}
