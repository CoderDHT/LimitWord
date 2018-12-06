# LimitWord
UITextField和UITextView限制字数
效果如下:
![image](https://github.com/CoderDHT/LimitWord/blob/master/LimitWord/limitDemo.gif)

# 相比于其他限制字数方案的优势
1. 对拼音输入友好, 允许输入时不会出现拼音输入一半不能继续输入的情况, 同时不允许输入时连拼音也不能输入
2. 将光标移到文本中间继续输入时不会替换末尾文本, 同时输入完光标不会移到末尾
3. 对粘贴处理妥当, 不会因为粘贴导致光标位置错乱
4. 对 delegate 和 UIMenuController 没有任何影响

有任何问题欢迎issues我(*^▽^*)
