this.dogoAnno = function(){
}
dogoAnno.prototype = {
  loadAnnotations: function(annotations){
    var annotations = [annotations];
    anno.addAnnotation(annotations[0]);
  },
  activateSelector: function(){
    anno.activateSelector();
  },
  setCurrentSlide: function(slideNumber){
    DOGOANNO.slideNumber = '';
    DOGOANNO.slideNumber = slideNumber;
  },
  updateComments: function(text){
    $('#messages').append(text);
  },
  load: function(){
    var reg = /^\d+$/
    if(document.URL.split('/')[3] == 'decks' && reg.test(document.URL.split('/')[4])){
      anno.makeAnnotatable(document.getElementById('document'));
      anno.addHandler('onAnnotationCreated', function(annotation) {
        DOGOANNO.updateComments(annotation.text);
        DOGOANNO.save(annotation);
      });
    }
  },
  reset: function(){
    anno.reset();
  },
  destroy: function(){
    anno.destroy();
  },
  save: function(annotation){
    //save all annotations in a content column as key/value in the slides model
    function method1(){
      return '/annotations';
    }

    function method2(){
    }
    $.ajax({
       url:method1(),
       method: "POST",
       data: { annotation: annotation, deck_id: annotation.context.split("/").slice(-1)[0], id: DOGOANNO.slideNumber },
       success:function(){
       method2();
    }
    })
  }
}

DOGOANNO = new dogoAnno();
