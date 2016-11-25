this.dogoAnno = {}

dogoAnno.load = function(){
  anno.makeAnnotatable(document.getElementById('document'));
  anno.addHandler('onAnnotationCreated', function(annotation) {
    dogoAnno.updateComments(annotation.text);
    dogoAnno.save(annotation);
  });
}
dogoAnno.initialize = function(){
  
}
dogoAnno.updateComments = function(text){
  $('#messages').append(text);
}
dogoAnno.setCurrentSlide = function(slideNumber){
  dogoAnno.slideNumber = '';
  dogoAnno.slideNumber = slideNumber;
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
dogoAnno.loadAnnotations = function(annotations){
  var annotations = [annotations];
  anno.addAnnotation(annotations[0]);
}
dogoAnno.test = function(){
  alert('works!');
}
dogoAnno.save = function(annotation){
  //save all annotations in a content column as key/value in the slides model
  function method1(){
    return '/annotations';
  }

  function method2(){
  }

  $.ajax({
     url:method1(),
     method: "POST",
     data: { annotation: annotation, deck_id: annotation.context.split("/").slice(-1)[0], id: dogoAnno.slideNumber },
     success:function(){
     method2();
  }
  })
}
