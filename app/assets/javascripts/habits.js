document.addEventListener('turbolinks:load', function() {
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
  }
});
