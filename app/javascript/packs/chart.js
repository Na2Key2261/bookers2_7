

import Chart from 'chart.js';

document.addEventListener('DOMContentLoaded', () => {
  // グラフの表示ロジックを記述
  // 例: 過去7日間のデータを使った折れ線グラフ
  const ctx = document.getElementById('postChart').getContext('2d');
  const dates = <%= raw @past_seven_days_counts.keys.to_json %>;
  const counts = <%= raw @past_seven_days_counts.values.to_json %>;

  new Chart(ctx, {
    type: 'line',
    data: {
      labels: dates,
      datasets: [{
        label: '過去7日間の投稿数',
        data: counts,
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 2,
        fill: false,
      }],
    },
  });
});
