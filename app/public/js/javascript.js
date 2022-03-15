(function () {
  const resultUrl = document.querySelector(".content.result #url");

  if (resultUrl) {
    function copyUrl(event) {
      event.preventDefault();

      resultUrl.select();
      document.execCommand("copy");
    }

    function noOp(event) {
      event.preventDefault();
    }
    
    resultUrl.addEventListener("cut", noOp);
    resultUrl.addEventListener("paste", noOp);
    resultUrl.addEventListener("keypress", noOp);
    resultUrl.addEventListener("click", copyUrl);
    document.querySelector(".content.result .copy-url").addEventListener("click", copyUrl);
  }
})();