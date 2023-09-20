$(document).on('turbolinks:load', function() {
    $(window).on('scroll', function() {
        var scrollHeight = $(document).height();
        var scrollPosition = $(window).height() + $(window).scrollTop();
        if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
              $('.jscroll').jscroll({
                contentSelector: '.scroll-list',
                nextSelector: 'a.next',
                loadingHtml: '読み込み中'
              });
        }
    });
  });