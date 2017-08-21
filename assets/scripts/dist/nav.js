"use strict";

$(function() {
    var n = $("body"), c = n.children("nav").find(".hamburger"), i = $("#fullsize_nav").find(".cancel");
    c.on("click", function() {
        n.addClass("menu");
    }), i.on("click", function() {
        n.removeClass("menu");
    });
});