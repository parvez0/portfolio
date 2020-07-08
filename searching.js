const sleep = (time) => {
    return new Promise(resolve => {
        setTimeout(() => { resolve(); }, time)
    })
}

const resetFields = async () => {
    const numbers = $('.numbers').children();
    for(let i = 0; i < numbers.length; i++) {
        const childElement = $('.numbers').children().eq(i);
        if(!childElement.hasClass('search-effect') && !childElement.hasClass('search-success')){
            break;
        }
        const num = childElement.text();
        $(`#searching_${num}`).removeClass('search-effect');
        $(`#searching_${num}`).removeClass('search-success');
        await sleep(0.009);
    }
}
/**
 * performers a linear search on the given array
 * @returns {Promise<void>}
 */
const startSearching = async () => {
    const key = $('#number-to-search').val();
    if(!key || isNaN(key)){
        alert('Please provide a number to search');
        return;
    }
    const numbers = $('.numbers').children();
    for(let i=0; i < numbers.length; i++) {
        const num = $('.numbers').children().eq(i).text();
        $(`#searching_${num}`).addClass('search-effect');
        await sleep(4);
        if (Number(key) === Number(num)) {
            $(`#searching_${num}`).addClass('search-success');
            break;
        }
    }
};

const generateNumbers = () => {
    let numberTags = '';
    for(let i=1; i <= 5000; i++){
        numberTags += `<p id="searching_${i}" class="number-class">${i}</p>`;
    }
    $(".numbers").append(numberTags);
}
