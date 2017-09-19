safari.self.addEventListener("message", handleMessage);

function handleMessage(message) {
    var selectedText = window.getSelection().toString();
    safari.extension.dispatchMessage("getURL", { "selectedText": selectedText });
}
