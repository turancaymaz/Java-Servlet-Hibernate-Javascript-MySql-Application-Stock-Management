let select_id = 0
$('#boxAction_add_form').submit( ( event ) => {
    event.preventDefault();

    const cname = $("#cname").val()
    const ptitle = $("#pname").val()
    const count = $("#count").val()
    const bNo = $("#bNo").val()

    const obj = {
        order_customer_id: cname,
        order_product_id: ptitle,
        order_count: count,
        order_receipt: bNo,
    }

    if ( select_id != 0 ) {
        // update
        obj["order_id"] = select_id;
    }
    $.ajax({
        url: './order-post',
        type: 'POST',
        data: { obj: JSON.stringify(obj) },
        dataType: 'JSON',
        success: function (data) {
            if ( data > 0 ) {
                alert("İşlem Başarılı")
                allOrder(cname)
            }else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })
})
function allOrder(cid) {

    $.ajax({
        url: './order-get?cid=' + cid,
        type: 'GET',
        dataType: 'JSON',
        success: function (data) {
            createRow(data);
        },
        error: function (err) {
            console.log(err)
        }
    })
}
let globalArr = []
let receipt_no = 0;
function createRow(data) {
    globalArr = data;
    let html = ``
    for (let i = 0; i < data.length; i++) {
        const itm = data[i];


        html += `<tr role="row" class="odd">
             <td>` + itm.order_id + `</td>
             <td>` + itm.p_title + `</td>
             <td>` + itm.p_salesPrice + `TL</td>
             <td>` + itm.order_count + `</td>
             <td>` + itm.cu_name + `</td>
             <td>` + itm.order_receipt + `</td>
             <td class="text-right" >
               <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                 <button onclick="fncBoxDelete(` + itm.order_id + `)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
               </div>
             </td>
            </tr>`;
    }
    if (globalArr.length > 0) {
        receipt_no = globalArr[0].order_receipt;
    }
    $('#tableRow').html(html);


}
$("#cname").on("change", function () {
    allOrder(this.value)

})
function fncBoxDelete(order_id) {
    const cname = $("#cname").val()
    let answer = confirm("Silmek istediğinizden emin misiniz?");
    if (answer) {
        $.ajax({
            url: './order-delete?order_id=' + order_id,
            type: 'DELETE',
            dataType: 'text',
            success: function (data) {
                if (data != "0") {
                    alert("Silindi.")
                    allOrder(cname);
                } else {
                    alert("Silme sırasında bir hata oluştu!");
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }
}

$(document).on('click', '#completeOrder', function (data) {

    const obj = {
        order_receipt: receipt_no,
    }


    $.ajax({
        url: './receipt-post',
        type: 'POST',
        data: {obj: JSON.stringify(obj)},
        dataType: 'JSON',
        success: function (data) {
            if (data > 0) {
                alert("Sipariş tamamlandı")
                allOrder($("#cname").val())

            } else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırasında hata oluştu!")
        }
    })


})