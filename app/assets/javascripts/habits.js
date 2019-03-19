document.addEventListener('turbolinks:load', function() {

  // スライダーの現在値を取得する
  const element = document.getElementsByClassName('progressRange');
  const setRangeValue = (element, target) => {
    return function(e) {
      target.innerHTML = `${element.value}%`;
    };
  };
  for (let i = 0; i < element.length; i++) {
    // form_for使うと自動で３つのinputタグが生成されるから、自分で追加したものは４つ目以降になる
    bar = element[i].getElementsByTagName('input')[3];
    target = element[i].getElementsByTagName('span')[0];
    bar.addEventListener('input', setRangeValue(bar, target));
  };

  // makeの画像保存
  const ruleForMake = document.getElementById('make-rule');
  if (ruleForMake !== null) {
    html2canvas(ruleForMake).then(function(canvas) {
    const canvasImage = canvas.toDataURL('image/png');
    document.getElementById('make-download').setAttribute('href', canvasImage);
    // スライダーがcanvasだとうまく描画されないため、画像には進捗は含めない
    document.getElementById('make-progress').classList.remove('d-none');
    });
  };

  // quitの画像保存
  const ruleForQuit = document.getElementById('quit-rule');
  if (ruleForQuit !== null) {
    html2canvas(ruleForQuit).then(function(canvas) {
    const canvasImage = canvas.toDataURL('image/png');
    document.getElementById('quit-download').setAttribute('href', canvasImage);
    // スライダーがcanvasだとうまく描画されないため、画像には進捗は含めない
    document.getElementById('quit-progress').classList.remove('d-none');
    });
  };
});
