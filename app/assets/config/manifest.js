//= link_tree ../images
//= link_directory ../stylesheets .css

$(function(){
    $('#ask-button').click(function(){
        $('#ask-form').slideToggle(300)
        return false
    })
})
