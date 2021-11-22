const sortStatus = Array(7).fill(false);

const quickSortTable = (colIndex) => {
	const table = document.getElementById("heroes");
	const rows = table.rows;
	const sortedRows = Array.from(rows).sort((row1, row2) => {
		const x = row1.getElementsByTagName("TD")[colIndex];
		const y = row2.getElementsByTagName("TD")[colIndex];
		
		if (!sortStatus[colIndex]) {
			if (colIndex == 0) {
				return Number(x.innerHTML) - Number(y.innerHTML);
			}
			return x.innerHTML.localeCompare(y.innerHTML);
		} else {
			if (colIndex == 0) {
				return Number(y.innerHTML) - Number(x.innerHTML);
			}
			return x.innerHTML.localeCompare(y.innerHTML) * -1;
		}
	});
	
	sortStatus[colIndex] = !sortStatus[colIndex];
	table.innerHTML = '';
	sortedRows.forEach(row => table.appendChild(row));
}