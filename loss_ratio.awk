BEGIN {
    # Khởi tạo mảng để tránh lỗi in trống
    print "--- ĐANG PHÂN TÍCH TỶ LỆ MẤT GÓI (PLR) ---"
}

{
    # Các cột chuẩn trong NS2 trace:
    # $1: event (s, r, d, f)
    # $8: flow id (fid)
    
    event = $1;
    fid = $8;

    # Đếm số gói tin được gửi đi (s) hoặc đẩy vào hàng đợi (+)
    if (event == "s" || event == "+") {
        sent[fid]++;
    }

    # Đếm số gói tin bị loại bỏ (d) do tràn hàng đợi
    if (event == "d") {
        dropped[fid]++;
    }
}

END {
    # Kiểm tra xem có dữ liệu nào được đọc không
    found = 0;
    for (id in sent) {
        found = 1;
        d = (id in dropped) ? dropped[id] : 0;
        s = sent[id];
        plr = (d / s) * 100;
        
        printf "Flow ID %d: [Gửi: %d | Mất: %d] --> PLR: %.2f%%\n", id, s, d, plr;
    }

    if (found == 0) {
        print "LỖI: Không tìm thấy dữ liệu trong file .tr!";
        print "Gợi ý: Kiểm tra xem file project.tr có dung lượng không (ls -lh project.tr)";
    }
    print "------------------------------------------"
}