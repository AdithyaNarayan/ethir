use std::{env, path::PathBuf};

fn main() {
    let proto_file = "./proto/api.proto";

    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());

    tonic_build::configure()
        .build_server(true)
        .file_descriptor_set_path(out_dir.join("spaceblock_descriptor.bin"))
        .out_dir("./src/api")
        .compile(&[proto_file], &["."])
        .unwrap_or_else(|e| panic!("protobuf compile error: {}", e));

    println!("cargo:rerun-if-changed={}", proto_file);
}
