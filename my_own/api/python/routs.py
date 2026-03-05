from typing import Optional, Dict
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from pathlib import Path
import logging, json, subprocess, fastapi, time

# Remember: These are local API. To start, run `uvicorn routs:app --reload`.

BASE_DIR = Path(__file__).resolve().parent
with open(BASE_DIR / "base_smartphones.json", "r", encoding="utf-8") as bsmt:
    bf_smartphones: Dict = json.load(bsmt)
with open(BASE_DIR / "open_smartphones.json", "r", encoding="utf-8") as osmt:
    op_smartphones: Dict = json.load(osmt)

def start_local_fast_api():
    global process
    process = subprocess.Popen(
        [
            "uvicorn",
            "my_own.api.python.routs:app",
            "--host", "0.0.0.0",
            "--port", "8000"
        ]
    )
    time.sleep(3)

def shutdown_local_fast_api():
    global process
    op_smartphones.clear()
    op_smartphones.update(bf_smartphones)
    save_smartphones_json()
    if process:
        process.terminate()

    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
    return fastapi.Response(status_code=200, content='Server shutting down...')

def save_smartphones_json():
    file_path = BASE_DIR / "open_smartphones.json"
    with open(file_path, "w", encoding="utf-8") as osmt:
        json.dump(op_smartphones, osmt, indent=2, ensure_ascii=False)

app = FastAPI(title="Smartphones API Server")

class Device_data(BaseModel):
    company: str
    model: Optional[str] = None
    release_year: Optional[float]
    release_price_usd: Optional[float] = None
    screen: Optional[str]
    processor: Optional[str]
    front_camera: Optional[str]
    batery_mah: Optional[float]
    memory_options: Optional[list[int]]

class Custom_API_GET:
    @app.get("/smartphones/devices",
            response_model=Dict,
            status_code=status.HTTP_200_OK)
    async def get_all_devices():
        return op_smartphones

    @app.get("/smartphones/devices/{brand}/{device_name}",
            response_model=Dict,
            status_code=status.HTTP_200_OK)
    async def get_specific_device(brand, device_name):
        return op_smartphones[brand][device_name]

    @app.get(
        "/smartphones/devices/{brand}",
        response_model=Dict,
        status_code=status.HTTP_200_OK
    )
    async def get_devices_by_brand(brand: str):
        if brand not in op_smartphones:
            logging.warning(f"Brand '{brand}' not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Brand '{brand}' not found."
            )

        logging.info(f"Fetching devices for brand: {brand}")
        return op_smartphones[brand]

class Custom_API_POST:
    @app.post("/smartphones/devices/new",
        response_model=Dict,
        status_code=status.HTTP_201_CREATED
        )
    async def new_device(brand: str, device_name: str, device_data: Device_data):
        if brand not in op_smartphones:
            op_smartphones[brand] = {}
            logging.info(f"Created new brand: {brand}")
        if device_name in op_smartphones[brand]:
            logging.warning(f"Device '{device_name}' already exists in brand '{brand}'.")
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"Device '{device_name}' already exists in brand '{brand}'. Use PUT to update."
            )

        op_smartphones[brand][device_name] = device_data.model_dump()
        save_smartphones_json()
        logging.info(f"Created device: {brand} - {device_name}")

        return {
            "message": f"Created device: {device_name}",
            "brand": brand,
            "device": device_name,
            "data": op_smartphones[brand][device_name]
        }

class Custom_API_PUT:
    @app.put("/smartphones/devices/{brand}/{device_name}")
    async def update_device_info(brand, device_name, device_data: Device_data):
        if brand not in op_smartphones:
            logging.error(f"Brand '{brand}' not found for update")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Brand '{brand}' not found"
            )
        if device_name not in op_smartphones[brand]:
            logging.error(f"Device '{device_name}' not found for update")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Device '{device_name}' not found"
            )

        op_smartphones[brand][device_name] = device_data.model_dump()
        save_smartphones_json()
        logging.info(f"Device updated: {brand} - {device_name}")

        return {
            "message": f"Created device: {device_name}",
            "brand": brand,
            "device": device_name,
            "data": op_smartphones[brand][device_name]
        }

class Custom_API_DELETE:
    @app.delete("/smartphones/devices/{brand}/{device_name}")
    async def delete_device(brand, device_name):
        if brand not in op_smartphones:
            logging.error(f"Brand '{brand}' not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Brand '{brand}' not found"
            )
        if device_name not in op_smartphones[brand]:
            logging.error(f"Device '{device_name}' not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Device '{device_name}' not found"
            )

        del op_smartphones[brand][device_name]
        save_smartphones_json()
        logging.info(f"Device deleted")

        return {
            "message": f"Device '{device_name}' deleted successfully",
            "brand": brand,
            "device": device_name
}

    @app.delete("/smartphones/devices/{brand}")
    async def delete_brand(brand):
        if brand not in op_smartphones:
            logging.error(f"Brand '{brand}' not found")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Brand '{brand}' not found"
            )

        del op_smartphones[brand]
        save_smartphones_json()
        logging.info(f"Brand deleted")


