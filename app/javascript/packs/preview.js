$(document).on('turbolinks:load', function() {
  $("#preview_button, #clip_preview_button").click(function() {
    var url = $("#clip_url").val();
    var content_title = $("#content_title").val();
    var tag_list = $("#tag_list").val();

    $.ajax({
        url: "/clip_posts/get_clip",
        method: "GET",
        data: {url: url, content_title: content_title, tag_list: tag_list }
    })
  })
})