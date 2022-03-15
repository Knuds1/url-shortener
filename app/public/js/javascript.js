const resultUrl = document.getElementById("url");

function copyUrl(event) {
  event.preventDefault();

  resultUrl.select();
  document.execCommand("copy");
}

function noOp(event) {
  event.preventDefault();
}

if (resultUrl) {
  resultUrl.addEventListener("click", copyUrl);
  resultUrl.addEventListener("keypress", noOp);
  document.getElementById("copy-url").addEventListener("click", copyUrl);
}