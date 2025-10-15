if (visible) {
    update_scroll();
}

// move below all order cards
with (obj_card_order) {
	depth = other.depth - 1;
}