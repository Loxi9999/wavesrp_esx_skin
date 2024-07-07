window.onload = function(){
    let max = {}
    let min = {}

    const iconList = {
        'beard_1': 'fa-solid fa-beard',
        'sex': 'fa-solid fa-venus-mars',
        'mom': 'fa-solid fa-venus',
        'dad': 'fa-solid fa-mars',
        'face_md_weight': 'fa-solid fa-weight-hanging',
        'skin_md_weight': 'fa-solid fa-weight-hanging',
        'nose_1': 'fa-solid fa-face-kiss',
        'nose_2': 'fa-solid fa-face-kiss',
        'nose_3': 'fa-solid fa-face-kiss',
        'nose_4': 'fa-solid fa-face-kiss',
        'nose_5': 'fa-solid fa-face-kiss',
        'nose_6': 'fa-solid fa-face-kiss',
        'cheeks_1': 'fa-solid fa-cheese',
        'cheeks_2': 'fa-solid fa-cheese',
        'cheeks_3': 'fa-solid fa-cheese',
        'lip_thickness': 'fa-solid fa-smile',
        'jaw_1': 'fa-solid fa-skull',
        'jaw_2': 'fa-solid fa-skull',
        'chin_1': 'fa-solid fa-child',
        'chin_2': 'fa-solid fa-child',
        'chin_3': 'fa-solid fa-child',
        'chin_4': 'fa-solid fa-child',
        'neck_thickness': 'fa-solid fa-tshirt',
        'hair_1': 'fa-solid fa-cut',
        'hair_2': 'fa-solid fa-cut',
        'hair_color_1': 'fa-solid fa-paint-brush',
        'hair_color_2': 'fa-solid fa-paint-brush',
        'tshirt_1': 'fa-solid fa-shirt',
        'tshirt_2': 'fa-solid fa-shirt',
        'torso_1': 'fa-solid fa-shirt',
        'torso_2': 'fa-solid fa-shirt',
        'decals_1': 'fa-solid fa-star',
        'decals_2': 'fa-solid fa-star',
        'arms': 'fa-solid fa-fist-raised',
        'arms_2': 'fa-solid fa-fist-raised',
        'pants_1': 'fa-solid fa-socks',
        'pants_2': 'fa-solid fa-socks',
        'shoes_1': 'fa-solid fa-shoe-prints',
        'shoes_2': 'fa-solid fa-shoe-prints',
        'mask_1': 'fa-solid fa-mask',
        'mask_2': 'fa-solid fa-mask',
        'bproof_1': 'fa-solid fa-vest',
        'bproof_2': 'fa-solid fa-vest',
        'chain_1': 'fa-solid fa-link',
        'chain_2': 'fa-solid fa-link',
        'helmet_1': 'fa-solid fa-hard-hat',
        'helmet_2': 'fa-solid fa-hard-hat',
        'glasses_1': 'fa-solid fa-glasses',
        'glasses_2': 'fa-solid fa-glasses',
        'watches_1': 'fa-solid fa-clock',
        'watches_2': 'fa-solid fa-clock',
        'bracelets_1': 'fa-solid fa-ring',
        'bracelets_2': 'fa-solid fa-ring',
        'bags_1': 'fa-solid fa-shopping-bag',
        'bags_2': 'fa-solid fa-shopping-bag',
        'eye_color': 'fa-solid fa-eye',
        'eye_squint': 'fa-solid fa-eye-slash',
        'eyebrows_1': 'fa-solid fa-cut',
        'eyebrows_2': 'fa-solid fa-cut',
        'eyebrows_3': 'fa-solid fa-cut',
        'eyebrows_4': 'fa-solid fa-cut',
        'eyebrows_5': 'fa-solid fa-cut',
        'eyebrows_6': 'fa-solid fa-cut',
        'makeup_1': 'fa-solid fa-paint-brush',
        'makeup_2': 'fa-solid fa-paint-brush',
        'makeup_3': 'fa-solid fa-paint-brush',
        'makeup_4': 'fa-solid fa-paint-brush',
        'lipstick_1': 'fa-solid fa-palette',
        'lipstick_2': 'fa-solid fa-palette',
        'lipstick_3': 'fa-solid fa-palette',
        'lipstick_4': 'fa-solid fa-palette',
        'ears_1': 'fa-solid fa-gem',
        'ears_2': 'fa-solid fa-gem',
        'chest_1': 'fa-solid fa-chess-rook',
        'chest_2': 'fa-solid fa-chess-rook',
        'chest_3': 'fa-solid fa-chess-rook',
        'bodyb_1': 'fa-solid fa-child',
        'bodyb_2': 'fa-solid fa-child',
        'bodyb_3': 'fa-solid fa-child',
        'bodyb_4': 'fa-solid fa-child',
        'age_1': 'fa-solid fa-birthday-cake',
        'age_2': 'fa-solid fa-birthday-cake',
        'blemishes_1': 'fa-solid fa-bug',
        'blemishes_2': 'fa-solid fa-bug',
        'blush_1': 'fa-solid fa-blender',
        'blush_2': 'fa-solid fa-blender',
        'blush_3': 'fa-solid fa-blender',
        'complexion_1': 'fa-solid fa-sun',
        'complexion_2': 'fa-solid fa-sun',
        'sun_1': 'fa-solid fa-sun',
        'sun_2': 'fa-solid fa-sun',
        'moles_1': 'fa-solid fa-face-sad-cry',
        'moles_2': 'fa-solid fa-face-sad-cry',
        'beard_1': 'fa-solid fa-face-sad-cry',
        'beard_2': 'fa-solid fa-face-sad-cry',
        'beard_3': 'fa-solid fa-face-sad-cry',
        'beard_4': 'fa-solid fa-face-sad-cry',
    };

    let isTattooShop = false;

    window.addEventListener("message", function(event){
        let data = event.data
        if (data.action == "OpenMenu"){
            isTattooShop = data.tattooShop
            $(".skinmenu-items").html("")

            $(".skinmenu-items").prepend('<input type="text" id="searchInput" placeholder="Wyszukaj...">');

            let elements = data.elements
            elements.forEach(element => {
                let label = element.label
                let name = element.name
                let value = element.value
                let maxb = element.max
                let minb = element.min
                max[name] = maxb
                min[name] = minb
                $(".skinmenu-items").append(`
                    <div class="item `+ name +`">
                        <div class="title">
                        <i class="` + iconList[name] + `"></i>
                            <span> `+ label +` </span>
                        </div>
                        <input min="`+ min[name] +`" max="`+ max[name] +`" step="1" oninput="changeInput('`+ name +`', this.value)" type="range" class="range value" value="`+ value +`">
                        <div class="number">
                            <i class="leftArrow fa-solid fa-angles-left" onclick="change('-','`+ name +`')"></i>
                            <input min="`+ min[name] +`" max="`+ max[name] +`" step="1" oninput="changeInput('` + name + `', this.value)" type="number" class="value" value="`+ value +`">
                            <i class="rightArrow fa-solid fa-angles-right" onclick="change('+','`+ name +`')"></i>
                        </div>
                    </div>
                `)
            })

            $("#searchInput").on("input", function(){
                filterValue = $(this).val().toLowerCase();
                $(".item").each(function(){
                    let itemName = $(this).find('.title > span').text().toLowerCase();
                    if (itemName.includes(filterValue)) {
                        $(this).fadeIn(100);
                    } else {
                        $(this).fadeOut(100);
                    }
                });
            });

            $("body").show()
        } else if (data.action == "UpdateVals"){
            let namee = data.name
            let maxe = data.max
            let mine = data.min
            max[namee] = maxe
            min[namee] = mine
            $(".item." + namee + " > .number > input").attr("max", maxe)
            $(".item." + namee + " > .number > input").attr("min", mine)
            $(".item." + namee + " > .range").attr("max", maxe)
            $(".item." + namee + " > .range").attr("min", mine)

            if (data.value !== -1) {
                $(".item." + namee + " > .number > input").val(data.value)
                $(".item." + namee + " > .range").val(data.value)
            }
        } else if (data.action == "setRot"){
            $(".skinmenu-controls-item.rotation .range").attr("max", data.angle + 180)
            $(".skinmenu-controls-item.rotation .range").attr("min", data.angle - 180)
            $(".skinmenu-controls-item.rotation .range").val(data.angle)
        }
    })
/*no co mam powiedziec skaza zapomial loadera dac pozdro loxi topka*/
    changeInput = function(name, value)
    {
        $(".item." + name + " > .number > input").val(Number(value))
        $(".item." + name + " > .range").val(Number(value))
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            name: name,
            value: Number(value),
            isTattooShop: isTattooShop
        }));

    }

    change = function(type, name){
        let value = Number($(".item." + name + " > .range").val())
        if (type == '+')
        {
            value = value + 1
            if (value > max[name]) {
                return
            }
        }
        else if (type == '-')
        {
            value = value - 1
            if (value < min[name]) {
                return
            }
        }
        $(".item." + name + " > .number > input").val(value)
        $(".item." + name + " > .range").val(value)
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            name: name,
            value: value,
            isTattooShop: isTattooShop
        }));
    }

    $(".skinmenu-menuac > .submit").on("click", function(){
        $("body").hide()
        $.post(`https://${GetParentResourceName()}/submit`, JSON.stringify({
            isTattooShop: isTattooShop
        }));
    })

    $(".skinmenu-menuac > .cancel").on("click", function(){
        $("body").hide()
        $.post(`https://${GetParentResourceName()}/cancel`, JSON.stringify({
            isTattooShop: isTattooShop
        }));
        isTattooShop = false
    })

    $(".skinmenu-controls-item.rotation .range").on("input", function(){
        let value = Number($(".skinmenu-controls-item.rotation .range").val())
        $.post(`https://${GetParentResourceName()}/rotation`, JSON.stringify({
            value: value
        }));
    })

    $(".skinmenu-controls-item.heading .range").on("input", function(){
        let value = Number($(".skinmenu-controls-item.heading .range").val())
        $.post(`https://${GetParentResourceName()}/heading`, JSON.stringify({
            value: value
        }));
    })

    $(".skinmenu-controls-item.offset .range").on("input", function(){
        let value = Number($(".skinmenu-controls-item.offset .range").val())
        $.post(`https://${GetParentResourceName()}/offset`, JSON.stringify({
            value: value
        }));
    })
/* /l/o/x/i/t/o/p/k/a*/
    $(".skinmenu-menucloth > .items > .fa-helmet-safety").on("click", function(){
        $(".skinmenu-controls-item.offset .range").val("0.7")
        let value1 = Number($(".skinmenu-controls-item.offset .range").val())
        $.post(`https://${GetParentResourceName()}/offset`, JSON.stringify({
            value: value1
        }));

        $(".skinmenu-controls-item.heading .range").val("0.05")
        let value2 = Number($(".skinmenu-controls-item.heading .range").val())
        $.post(`https://${GetParentResourceName()}/heading`, JSON.stringify({
            value: value2
        }));
    })

    $(".skinmenu-menucloth > .items > .fa-shirt").on("click", function(){
        $(".skinmenu-controls-item.offset .range").val("0.25")
        let value1 = Number($(".skinmenu-controls-item.offset .range").val())
        $.post(`https://${GetParentResourceName()}/offset`, JSON.stringify({
            value: value1
        }));

        $(".skinmenu-controls-item.heading .range").val("0.25")
        let value2 = Number($(".skinmenu-controls-item.heading .range").val())
        $.post(`https://${GetParentResourceName()}/heading`, JSON.stringify({
            value: value2
        }));
    })

    $(".skinmenu-menucloth > .items > .fa-boot").on("click", function(){
        $(".skinmenu-controls-item.offset .range").val("-0.55")
        let value1 = Number($(".skinmenu-controls-item.offset .range").val())
        $.post(`https://${GetParentResourceName()}/offset`, JSON.stringify({
            value: value1
        }));

        $(".skinmenu-controls-item.heading .range").val("0.5")
        let value2 = Number($(".skinmenu-controls-item.heading .range").val())
        $.post(`https://${GetParentResourceName()}/heading`, JSON.stringify({
            value: value2
        }));
    })
}