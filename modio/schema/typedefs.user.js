// ==UserScript==
// @name         mod.io typedefs
// @namespace    https://yal.cc/
// @version      0.1
// @description  try to take over the world!
// @author       YellowAfterlife
// @match        https://docs.mod.io/
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    function proc(table) {
        let out = '';
        for (let row of table.querySelectorAll(`tbody tr:not(.level)`)) {
            let name = row.children[0].childNodes[0].textContent;
            //
            let typeCell = row.children[1];
            let typeLink = typeCell.querySelector('a');
            let type;
            if (typeLink) {
                type = typeLink.innerText.trim();
                if (type.endsWith(' Object')) {
                    type = type.substring(0, type.length - ' Object'.length);
                }
                type = 'Modio' + type.split(' ').join('');
            } else {
                type = row.children[1].childNodes[0].textContent.trim().replace('[]', '');
                type = type.replace('[]', '');
                switch (type) {
                    case 'integer': type = 'Int'; break;
                    case 'string': type = 'String'; break;
                    case 'boolean': type = 'Bool'; break;
                }
            }
            if (typeCell.textContent.includes('[]')) type = `ModioArray<${type}>`;
            //
            let docIndex = row.children.length - 1;
            let doc = row.children[docIndex].innerText;
            for (let a of row.children[docIndex].querySelectorAll(`a`)) doc += '\n@see ' + a.href;
            out += `\n\t\n\t/**\n\t * ${doc.split('\n').join('\n\t * ')}\n\t */`;
            out += `\n\t`;
            if (row.children.length == 4 && row.children[2].textContent.trim() == '') {
                out += `@:optional `;
            }
            out += `var ${name}:${type};`;
        }
        console.log(table, out);
        navigator.clipboard.writeText(out.trimLeft());
    }
    for (let table of document.querySelectorAll('table')) {
        //if (!table.querySelector('notcollapsed')) continue;
        if (table.querySelector('tr').children.length > 4) continue;
        let button = document.createElement('input');
        button.type = 'button';
        button.value = 'Copy typedef';
        button.style.marginLeft = '20px';
        button.style.fontSize = '85%';
        button.onclick = (function(table) {
            return () => proc(table);
        })(table);
        table.parentElement.insertBefore(button, table);
    }
})();
