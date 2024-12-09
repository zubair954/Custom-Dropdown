import 'package:flutter/material.dart';

typedef ShowItemPropertyInDropDown<T> = String Function(T item);

class CustomTextField<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ShowItemPropertyInDropDown<T>? itemAsString;
  final Color? dropDownColor;
  const CustomTextField(
      {super.key,
      required this.items,
      this.itemAsString,
      this.selectedItem,
      this.dropDownColor});

  @override
  State<CustomTextField<T>> createState() => _CustomTextFieldState<T>();
}

class _CustomTextFieldState<T> extends State<CustomTextField<T>> {
  OverlayEntry? entry;
  final layerLink = LayerLink();
  FocusNode node = FocusNode();
  TextEditingController txt = TextEditingController();
  T? selectedItem;
  bool overlayShown = false;

  @override
  void dispose() {
    txt.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedItem != null) {
        txt.text = widget.itemAsString != null
            ? widget.itemAsString!(widget.selectedItem as T)
            : widget.selectedItem.toString();
        selectedItem = widget.selectedItem;
      }
    });

    // node.addListener(() {
    //   if (node.hasFocus) {
    //     showOverlay();
    //   } else {
    //     hideOverlay();
    //   }
    // });
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height),
              child: buildOverlay()),
        );
      },
    );
    if (entry != null) {
      overlay.insert(entry!);
    }
  }

  Widget buildOverlay() {
    return TapRegion(
      onTapOutside: (event) {
        hideOverlay();
        overlayShown = false;
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: widget.dropDownColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Expanded(
              child: Material(
                color: widget.dropDownColor,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    T item = widget.items[index];
                    return Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              onValSelected(item);
                            },
                            title: Text(widget.itemAsString != null
                                ? widget.itemAsString!(item)
                                : item.toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onValSelected(item),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            child: selectedItem == item
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 15,
                                  )
                                : null,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onValSelected(item) {
    selectedItem = item;
    txt.text = widget.itemAsString != null
        ? widget.itemAsString!(item)
        : item.toString();

    node.unfocus();
    hideOverlay();
    overlayShown = false;
  }

  hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        onTap: () {
          if (overlayShown == false) {
            // node.requestFocus();
            showOverlay();
            overlayShown = true;
          }
        },
        child: AbsorbPointer(
          child: SizedBox(
            height: 40,
            width: MediaQuery.sizeOf(context).width * 0.40,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    focusNode: node,
                    controller: txt,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                        hintText: "Select",
                        hintStyle: TextStyle(color: Colors.grey),
                        disabledBorder: InputBorder.none),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                // DropdownSearch()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
