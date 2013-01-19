$(document).ready(function(){
	//初始化工作
	(function(){
		$('.checkboxLabel').each(function(){
			$(this).after($('<br/>'));
		});
		$('.text_url').each(function(){
			var $a = $('<a>点击查看</a>').attr('href', $(this).val()).attr('target', 'view').click(function(){
				$('#view').show();
				$('#close').show();
			});
			$(this).after($a).remove();
		});
		$('#close').click(function(){$('#view').hide();$(this).hide();});
		
		//对集合类型进行初始化
		$('.collections').each(function(){
			//解析后端发过来的数据
			function parseParam(val){
				if(val == "[]"){
					return [];
				}else{
					val = val.slice(1, -1);
					return val.split(',');
				}
			}
			
			var vals = parseParam($(this).val()),
				name = $(this).attr('name');

			if(vals.length == 0){
				vals[0] = "";
			}
			//获取输入框所在td
			var $tr = $(this).next('tr').children('td').last();
			$tr.html("");
			
			//创建输入框div模板
			var template = function(key, value){
				var $input = $('<input>').val($.trim(value)).addClass('multi_input').attr('name', name + '[' + key + ']').data('id', key),
					$del = $('<a>').addClass('multi_button del').text('×').click(function(){
						$(this).closest('.multi_div').remove();
					});
				return $('<div>').addClass('multi_div').append($input).append($del);
			};
			
			//批量添加到tr中去
			for(var val in vals){
				$tr.append(template(val, vals[val]));
			}
			
			//添加add按钮
			var $add = $('<a>').addClass('multi_button add').text('+').click(function(){
				var key = parseInt($(this).prev('.multi_div').find('input.multi_input').data('id')) + 1;
				$(this).before(template(key, ""));
			});
			$tr.append($add);
			
			//重置该隐藏域的id，避免扰乱提交数据
			$(this).attr('name','');
		});
		
		//修复checkboxlist标签的name属性，保证提交时直接提交不需要action封装集合类型来处理
		//吐个槽，struts的这标签的name设计得太傻了，作者亲自用过么。。。
		$('.checkboxlist').each(function(){
		    var i = parseInt($(this).attr('id').split('-')[1]);
		    $(this).attr('name', $(this).attr('name') + "[" + i++ + "].id");
		});
		$('body').show();
	})();
	
});