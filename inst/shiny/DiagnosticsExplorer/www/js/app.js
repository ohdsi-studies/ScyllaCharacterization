setInputValue = function(params) {
  Shiny.setInputValue("jscookie", params);  
}

setCookie = function(params) {
  Cookies.set("ScyllaCharacterizationDiag", escape(params), { expires: 30 });
}

Shiny.addCustomMessageHandler("setCookie", function(params) {
  setCookie(params);
  setInputValue(params);
});

Shiny.addCustomMessageHandler("rmCookie", function(params) {
  Cookies.remove("ScyllaCharacterizationDiag");
  setInputValue(params);
});

Shiny.addCustomMessageHandler("alert", function(params) {
  alert(params)
});

$(document).on('shiny:sessioninitialized', function(event) {
  var cookie = Cookies.get("ScyllaCharacterizationDiag");
  if (typeof cookie !== "undefined") {
    setInputValue(cookie);
  } else {
    setCookie("");
    setInputValue("");
  }
});
