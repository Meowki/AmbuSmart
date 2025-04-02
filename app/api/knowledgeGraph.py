from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
import requests

from db.session import SessionLocal

router = APIRouter(
    prefix="/knowledge",
    tags=["knowledge"]
)

sign = "e29aa7d90a06f2dccf90562cde5762177b33ae72007eda445d807bce08e9efdf"

# 1. 获取实体相关三元组API -> /schema
@router.get("/schema")
def fetch_schema(entity: str):
    """
    调用 cpubmed.openi.org.cn 的 /graph/schema 接口，
    通过后端中转的方式返回数据给前端。
    :param entity: 实体名称（如 "糖尿病"）
    :param sign: 你的密钥
    :return: 接口返回的 JSON
    """
    api_url = "http://cpubmed.openi.org.cn/graph/schema"
    params = {
        "entity": entity,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        # print("DEBUG response.text:", response.text)  
        data = response.json()  # 解析 JSON
        return data
    except requests.JSONDecodeError as jde:
        raise HTTPException(
            status_code=500,
            detail=f"JSON 解析错误: {jde}. 原始响应: {response.text}"
        )
    except requests.RequestException as re:
        raise HTTPException(
            status_code=500, detail=f"请求异常: {re}"
        )




# 2. 获取三元组信息API -> /triple-info
@router.get("/triple-info")
def fetch_triple_info(ID: str):
    """
    调用 cpubmed.openi.org.cn 的 /graph/triple-info 接口
    用 ID 查询三元组信息
    """
    api_url = "http://cpubmed.openi.org.cn/graph/triple-info"
    params = {
        "ID": ID,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 triple-info 接口失败: {e}")



# 3. 医学分词API -> /cut


@router.get("/cut")
def fetch_cut(query: str):
    """
    调用 cpubmed.openi.org.cn 的 /graph/cut 接口
    用于对输入句子进行医学分词
    """
    api_url = "http://cpubmed.openi.org.cn/graph/cut"
    params = {
        "query": query,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 cut 接口失败: {e}")



# 4. 三元组匹配API -> /match


@router.get("/match")
def fetch_match(query: str):
    """
    调用 /graph/match 接口，对输入句子进行三元组匹配
    """
    api_url = "http://cpubmed.openi.org.cn/graph/match"
    params = {
        "query": query,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 match 接口失败: {e}")



# 5. 医学文献检索API -> /retrieve


@router.get("/retrieve")
def fetch_retrieve(query: str):
    """
    调用 /graph/retrieve 接口，对输入文本进行医学文献检索
    """
    api_url = "http://cpubmed.openi.org.cn/graph/retrieve"
    params = {
        "query": query,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 retrieve 接口失败: {e}")



# 6. 查找实体间三元组路径API -> /path


@router.get("/path")
def fetch_path(source_entity: str, target_entity: str):
    """
    调用 /graph/path 接口，查找实体间三元组路径
    """
    api_url = "http://cpubmed.openi.org.cn/graph/path"
    params = {
        "source-entity": source_entity,
        "target-entity": target_entity,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 path 接口失败: {e}")



# 7. 实体相似度计算API -> /similarity


@router.get("/similarity")
def fetch_similarity(ent1: str, ent2: str):
    """
    调用 /graph/similarity 接口，计算两个实体的相似度
    """
    api_url = "http://cpubmed.openi.org.cn/graph/similarity"
    params = {
        "ent1": ent1,
        "ent2": ent2,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 similarity 接口失败: {e}")



# 8. 获取相近的实体词 -> /similar-entity

@router.get("/similar-entity")
def fetch_similar_entity(entity: str):
    """
    调用 /graph/similar-entity 接口，获取相近的实体词列表
    """
    api_url = "http://cpubmed.openi.org.cn/graph/similar-entity"
    params = {
        "entity": entity,
        "sign": sign
    }
    try:
        response = requests.get(api_url, params=params, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"调用知识图谱 similar-entity 接口失败: {e}")
