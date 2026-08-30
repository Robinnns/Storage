// ============================================================
// 通用选择题组件 — assets/quiz.js
// 依赖 style.css 中的 .quiz 系列样式（含 correct/wrong/selected 状态）
//
// HTML 约定：
//   <div class="quiz" data-correct="B">
//     <p class="quiz-question">问题？</p>
//     <div class="quiz-options">
//       <button class="quiz-option" data-value="A">A. 选项A</button>
//       <button class="quiz-option" data-value="B">B. 选项B</button>
//       ...
//     </div>
//     <div class="quiz-feedback" data-good="✓ 正确！" data-bad="✗ 再想想——关键在……">
//     </div>
//   </div>
//
// data-correct = 正确选项的 data-value（"A"/"B"/"C"/"D"）
// data-good / data-bad 为可选反馈文案，缺省用通用文案
// ============================================================

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.quiz').forEach(function (quiz) {
    var correctValue = quiz.dataset.correct;
    var feedback = quiz.querySelector('.quiz-feedback');
    var goodText = (feedback && feedback.dataset.good) || '✓ 正确。';
    var badText  = (feedback && feedback.dataset.bad)  || '✗ 不对，再想想。';

    quiz.querySelectorAll('.quiz-option').forEach(function (opt) {
      opt.addEventListener('click', function () {
        if (quiz.dataset.locked) return;   // 已作答则锁定
        quiz.dataset.locked = '1';

        if (opt.dataset.value === correctValue) {
          // 答对
          opt.classList.add('correct');
          if (feedback) {
            feedback.classList.add('show', 'good');
            feedback.textContent = goodText;
          }
        } else {
          // 答错：标红该选项 + 高亮正确项
          opt.classList.add('wrong');
          quiz.querySelectorAll('.quiz-option').forEach(function (o) {
            if (o.dataset.value === correctValue) o.classList.add('selected');
          });
          if (feedback) {
            feedback.classList.add('show', 'bad');
            feedback.textContent = badText;
          }
        }
      });
    });
  });
});
